# frozen_string_literal: true

require "test_helper"
require "yaml"

class ComposeSecurityTest < ActiveSupport::TestCase
  test "standard compose publishes the web app on loopback by default" do
    compose = compose_config("compose.example.yml")

    assert_equal [ "${SURE_BIND_ADDRESS:-127.0.0.1}:${PORT:-3000}:3000" ], compose.dig("services", "web", "ports")
    assert_equal "${RAILS_ALLOWED_HOSTS:-localhost,127.0.0.1,[::1]}", compose.dig("x-rails-env", "RAILS_ALLOWED_HOSTS")
    assert_equal "${ACCOUNT_LOGO_DISCOVERY_ENABLED:-false}", compose.dig("x-rails-env", "ACCOUNT_LOGO_DISCOVERY_ENABLED")
  end

  test "AI compose keeps published services on loopback and enables web UI authentication" do
    compose = compose_config("compose.example.ai.yml")

    expected_ports = {
      "pipelock" => "${SURE_BIND_ADDRESS:-127.0.0.1}:${MCP_PROXY_PORT:-8889}:8889",
      "ollama" => "${SURE_BIND_ADDRESS:-127.0.0.1}:11434:11434",
      "ollama-webui" => "${SURE_BIND_ADDRESS:-127.0.0.1}:8080:8080",
      "openclaw" => "${SURE_BIND_ADDRESS:-127.0.0.1}:${OPENCLAW_GATEWAY_PORT:-18789}:18789",
      "web" => "${SURE_BIND_ADDRESS:-127.0.0.1}:${PORT:-3000}:3000"
    }

    expected_ports.each do |service, port|
      assert_includes compose.dig("services", service, "ports"), port
    end
    assert_includes compose.dig("services", "ollama-webui", "environment"), "WEBUI_AUTH=True"
    refute compose.dig("services", "ollama-webui", "environment").any? { |entry| entry.start_with?("WEBUI_SECRET_KEY=") }
    assert_equal "${EXTERNAL_ASSISTANT_TOKEN:-}", compose.dig("services", "openclaw", "environment", "OPENCLAW_GATEWAY_TOKEN")
    assert_equal "${RAILS_ALLOWED_HOSTS:-localhost,127.0.0.1,[::1]}", compose.dig("x-rails-env", "RAILS_ALLOWED_HOSTS")
    assert_equal "${ACCOUNT_LOGO_DISCOVERY_ENABLED:-false}", compose.dig("x-rails-env", "ACCOUNT_LOGO_DISCOVERY_ENABLED")
  end

  private
    def compose_config(filename)
      YAML.safe_load(Rails.root.join(filename).read, aliases: true)
    end
end
