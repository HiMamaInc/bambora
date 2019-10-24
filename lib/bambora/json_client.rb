# frozen_string_literal: true

module Bambora
  class JSONClient < Bambora::Client
    def request(method:, path: '', params: {}, body: {}, headers: {})
      resp = connection.request(
        method: method,
        path: path,
        params: params,
        body: body.to_json.to_s,
        headers: { 'Content-Type' => 'application/json' }.merge(headers),
      )

      parse_response(resp)
    rescue JSON::ParserError
      error_response(resp)
    end

    private

    def parse_response(resp)
      deep_transform_keys_in_object(JSON.parse(resp.body), &:to_sym)
    end

    def deep_transform_keys_in_object(object, &block)
      case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys_in_object(e, &block) }
        else
          object
      end
    end

    def error_response(resp)
      { status: resp.status, body: resp.body }
    end
  end
end
