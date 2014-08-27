require 'webmock/rspec'
require_relative '../lib/rainforest/integrations'

RSpec.configure do |config|

  def load_event_json(name)
    txt = File.read(Pathname(File.dirname(__FILE__)).join("fixtures", "#{name}.json"))
    json = JSON.load(txt)
    event = Rainforest::Integrations::Event.new(json)
  end

  def sample_event
    Rainforest::Integrations::Event.new(sample_event_payload)
  end

  def sample_job_failure_event
    Rainforest::Integrations::Event.new(sample_job_failure_event_payload)
  end

  def sample_event_payload
    {
      "name"=>"of_run_completion",
      "run"=>{
        "id"=>2,
        "created_at"=>"2014-08-22T17:21:12Z",
        "environment"=>{
          "id"=>2,
          "client_id"=>2,
          "default"=>false,
          "webhook"=>nil,
          "webhook_enabled"=>nil,
          "created_at"=>"2014-08-22T17:21:12.305Z",
          "updated_at"=>"2014-08-22T17:21:12.305Z",
          "name"=>"Staging"
        },
        "tests"=>[],
        "state"=>"queued",
        "result"=>"no_result",
        "current_progress"=>{
          "percent"=>0,
          "total"=>0,
          "complete"=>0,
          "eta"=>{
            "seconds"=>1800,
            "ts"=>"2014-08-22T11:51:12-06:00"
          },
          "no_result"=>0,
          "passed"=>0,
          "failed"=>0
        },
        "timestamps"=>{
          "created_at"=>"2014-08-22T17:21:12.306Z"
        },
        "stats"=>{
          "total_time_for_one_person"=>0.0,
          "total_time_for_rainforest"=>0.0,
          "total_rainforest_overhead"=>0.0,
          "speed_up"=>nil
        },
        "browsers"=>[],
        "requested_tests"=>[]
      },
      "browser_result"=>nil,
      "type"=>"run_failure",
      "is_failure"=>true,
      "ui_link"=>"http://app.example.org/runs/2"
    }
  end

  def sample_job_failure_event_payload
    {
      "name" => "of_test_failure",
      "run" => {
        "id" => 2,
        "created_at" => "2014-08-26T17:07:13Z",
        "environment" => {
          "id" => 2,
          "client_id" => 3,
          "default" => false,
          "webhook" => nil,
          "webhook_enabled" => nil,
          "created_at" => "2014-08-26T17:07:13.757Z",
          "updated_at" => "2014-08-26T17:07:13.757Z",
          "name" => "Staging"
        },
        "tests" => [],
        "state" => "queued",
        "result" => "no_result",
        "current_progress" => {
          "percent" => 0,
          "total" => 1,
          "complete" => 0,
          "eta" => {
            "seconds" => 1800,
            "ts" => "2014-08-26T11:37:14-06:00"
          },
          "no_result" => 0,
          "passed" => 0,
          "failed" => 0
        },
        "timestamps" => {
          "created_at" => "2014-08-26T17:07:13.758Z"
        },
        "stats" => {
          "total_time_for_one_person" => 0.0,
          "total_time_for_rainforest" => 0.0,
          "total_rainforest_overhead" => 0.0,
          "speed_up" => nil
        },
        "browsers" => [],
        "requested_tests" => []
      },
      "browser_result" => {
        "id" => 1,
        "created_at" => "2014-08-26T17:07:13Z",
        "name" => "chrome",
        "result" => "failed",
        "state" => "provisionally_complete",
        "failing_test" => {
          "id" => 1,
          "created_at" => "2014-08-26T17:07:13Z",
          "test_id" => 1,
          "site_id" => 1,
          "title" => "Check evolve open-source eyeballs works",
          "state" => "in_progress",
          "result" => "no_result",
          "start_uri" => "/",
          "run_mode" => "default",
          "editable" => false,
          "browsers" => [
            {
              "id" => 1,
              "created_at" => "2014-08-26T17:07:13Z",
              "name" => "chrome",
              "result" => "failed",
              "state" => "provisionally_complete"
            }
          ],
          "tags" => [],
          "steps" => [
            {
              "id" => 1,
              "created_at" => "2014-08-26T17:07:13Z",
              "test_id" => 1,
              "action" => "Click on the link fool!",
              "response" => "Did you click the link?",
              "browsers" => [
                {
                  "name" => "chrome",
                  "result" => "failed",
                  "feedback" => [
                    {
                      "screenshots" => [
                        {
                          "url" => "https://test-bucket.s3.amazonaws.com/1aa8a3b8-c3de-4404-a028-c14653371528?AWSAccessKeyId=AKIAIRNHYYHHQIYMNZWA&Expires=1566839234&Signature=gakUDkkV9i8BeH3ANoyOm5nMWE8%3D",
                          "thumbnail_url" => nil
                        }
                      ],
                      "note" => "",
                      "user_agent" => nil,
                      "submitted_at" => "2014-08-26T17:07:14.000Z"
                    }
                  ]
                },
                {
                  "name" => "firefox",
                  "result" => "no_result",
                  "feedback" => []
                },
                {
                  "name" => "ie8",
                  "result" => "no_result",
                  "feedback" => []
                },
                {
                  "name" => "ie9",
                  "result" => "no_result",
                  "feedback" => []
                }
              ]
            }
          ],
          "dry_run_url" => nil
        }
      },
      "type" => "test_failure",
      "is_failure" => true,
      "ui_link" => "http://app.example.org/runs/2"
    }
  end

end
