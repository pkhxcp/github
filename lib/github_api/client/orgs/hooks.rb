# encoding: utf-8

module Github
  # The Organizations Hooks API manages the post-receive web and
  # service hooks for an organization.
  class Client::Orgs::Hooks < API

    VALID_HOOK_PARAM_NAMES = %w[
      name
      config
      active
      events
      add_events
      remove_events
    ].freeze # :nodoc:

    # Active hooks can be configured to trigger for one or more events.
    # The default event is push. The available events are:
    VALID_HOOK_PARAM_VALUES = {
      'events' => %w[
        push
        issues
        issue_comment
        commit_comment
        pull_request
        gollum
        watch
        download
        fork
        fork_apply
        member
        public
      ]
    }.freeze # :nodoc:

    REQUIRED_PARAMS = %w[ name config ].freeze # :nodoc:

    # List organization hooks
    #
    # @example
    #   github = Github.new
    #   github.orgs.hooks.list 'org-name'
    #   github.orgs.hooks.list 'org-name' { |hook| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:org])

      response = get_request("/orgs/#{arguments.org}/hooks", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single hook
    #
    # @example
    #   github = Github.new
    #   github.orgs.hooks.get 'org-name', 'hook-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:org, :id])

      get_request("/orgs/#{arguments.org}/hooks/#{arguments.id}", arguments.params)
    end
    alias :find :get

    # Create a hook
    #
    # @param [Hash] params
    # @input params [String] :name
    #   Required. The name of the service that is being called.
    # @input params [Hash] :config
    #   Required. Key/value pairs to provide settings for this hook.
    #   These settings vary between the services and are defined in
    #   the github-services repository. Booleans are stored internally
    #   as “1” for true, and “0” for false. Any JSON true/false values
    #   will be converted automatically.
    # @input params [Array] :events
    #   Determines what events the hook is triggered for. Default: ["push"]
    # @input params [Boolean] :active
    #   Determines whether the hook is actually triggered on pushes.
    #
    # To create a webhook, the following fields are required by the config:
    #
    # @input config [String] :url
    #   A required string defining the URL to which the payloads
    #   will be delivered.
    # @input config [String] :content_type
    #   An optional string defining the media type used to serialize
    #   the payloads. Supported values include json and form.
    #   The default is form.
    # @input config [String] :secret
    #   An optional string that’s passed with the HTTP requests as
    #   an X-Hub-Signature header. The value of this header is
    #   computed as the HMAC hex digest of the body,
    #   using the secret as the key.
    # @input config [String] :insecure_ssl
    #   An optional string that determines whether the SSL certificate
    #   of the host for url will be verified when delivering payloads.
    #   Supported values include "0" (verification is performed) and
    #   "1" (verification is not performed). The default is "0".or instance, if the library doesn't get updated to permit a given parameter the api call won't work, however if we skip permission all together, the endpoint should always work provided the actual resource path doesn't change. I'm in the process of completely removing the permit functionality.
    #
    # @example
    #   github = Github.new
    #   github.orgs.hooks.create 'org-name',
    #     name:  "web",
    #     active: true,
    #     config: {
    #       url: "http://something.com/webhook"
    #     }
    #   }
    #
    # @api public
    def create(*args)
      arguments(args, required: [:org]) do
        #permit VALID_HOOK_PARAM_NAMES, recursive: false
        assert_required REQUIRED_PARAMS
      end

      post_request("/orgs/#{arguments.org}/hooks", arguments.params)
    end

    # Edit a hook
    #
    # @param [Hash] params
    # @input params [Hash] :config
    #   Required. Key/value pairs to provide settings for this hook.
    #   These settings vary between the services and are defined in
    #   the github-services repository. Booleans are stored internally
    #   as “1” for true, and “0” for false. Any JSON true/false values
    #   will be converted automatically.
    # @input params [Array] :events
    #   Determines what events the hook is triggered for. Default: ["push"]
    # @input params [Array] :add_events
    #   Determines a list of events to be added to the list of events
    #   that the Hook triggers for.
    # @input params [Array] :remove_events
    #   Determines a list of events to be removed from the list of
    #   events that the Hook triggers for.
    # @input params [Boolean] :active
    #   Determines whether the hook is actually triggered on pushes.
    #
    # @example
    #  github = Github.new
    #  github.orgs.hooks.edit 'org-name', 'hook-id',
    #    "name" => "campfire",
    #    "active" =>  true,
    #    "config" =>  {
    #      "subdomain" => "github",
    #      "room" =>  "Commits",
    #      "token" => "abc123"
    #    }
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:org, :id]) do
        permit VALID_HOOK_PARAM_NAMES, recursive: false
        assert_required REQUIRED_PARAMS
      end

      patch_request("/orgs/#{arguments.org}/hooks/#{arguments.id}", arguments.params)
    end

    # Ping a hook
    #
    # This will trigger a ping event to be sent to the hook.
    #
    # @example
    #   github = Github.new
    #   github.orgs.hooks.ping 'org-name', 'hook-id'
    #
    # @api public
    def ping(*args)
      arguments(args, required: [:org, :id])

      post_request("/orgs/#{arguments.org}/hooks/#{arguments.id}/pings", arguments.params)
    end

    # Delete a hook
    #
    # @example
    #   github = Github.new
    #   github.orgs.hooks.delete 'org-name', 'hook-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:org, :id])

      delete_request("/orgs/#{arguments.org}/hooks/#{arguments.id}", arguments.params)
    end
  end # Client::Orgs::Hooks
end # Github
