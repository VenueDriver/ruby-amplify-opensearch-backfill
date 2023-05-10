module AmplifyOpenSearchBackfill

  class CLI < Thor
    default_task :help

    desc 'status', 'Check current OpenSearch configuration for this Amplify app.'
    option :api_name, required: true, desc: 'Amplify API name', banner: ''
    option :model_name, required: true, desc: 'Amplify model name', banner: ''
    def status
      AmplifyOpenSearchBackfill::Introspector.new(
        api_name:   options['api_name'],
        model_name: options['model_name']
      ).status
    end

    # TODO: This idea from GitHub Copilot seems useful.
    # desc 'find', 'Find DynamoDB items that are not in OpenSearch.'
    # def find
    # end

    desc 'reindex', 'Reindex DynamoDB items for one model to OpenSearch.'
    option :api_name, required: true, desc: 'Amplify API name', banner: ''
    option :model_name, required: true, desc: 'Amplify model name', banner: ''
    def reindex
    end

    desc 'raw', 'Reindex but with raw parameters.'
    option :rn, required: true, desc: 'AWS region', banner: ''
    option :tn, required: true, desc: 'DynamoDB table name (not the model name)', banner: ''
    option :lfarn, required: true, desc: 'Lambda function ARN that posts data to OpenSearch', banner: ''
    option :esarn, required: true, desc: 'Event source ARN', banner: ''
    def raw
      domain = AmplifyOpenSearchBackfill::Processor.new
      credentials = Aws::SharedCredentials.new

      domain.import_dynamodb_items_to_es(
        options[:table_name],
        options[:region],
        options[:event_source_arn],
        options[:lambda_function],
        300,
        credentials
      )
    end

    def self.exit_on_failure?
      true
    end

  end

end