require 'webmock/rspec'
require_relative '../lib/rainforest/integrations'

RSpec.configure do |config|

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
        "id" => 28,
        "created_at" => "2014-08-22T21:09:17Z",
        "environment" => {
          "id" => 28,
          "client_id" => 30,
          "default" => false,
          "webhook" => nil,
          "webhook_enabled" => nil,
          "created_at" => "2014-08-22T21:09:17.294Z",
          "updated_at" => "2014-08-22T21:09:17.294Z",
          "name" => "Staging"
        },
        "tests" => [],
        "state" => "queued",
        "result" => "no_result",
        "current_progress" => {
          "percent" => 100,
          "total" => 1,
          "complete" => 1,
          "eta" => {
            "seconds" => 0,
            "ts" => "2014-08-22T15:09:17-06:00"
          },
          "no_result" => 0,
          "passed" => 0,
          "failed" => 0
        },
        "timestamps" => {
          "created_at" => "2014-08-22T21:09:17.295Z"
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
        "id" => 2,
        "created_at" => "2014-08-22T21:09:17Z",
        "name" => "chrome",
        "result" => "failed",
        "state" => "complete",
        "failing_test" => {
          "id" => 2,
          "created_at" => "2014-08-22T21:09:17Z",
          "test_id" => 2,
          "site_id" => 2,
          "title" => "Check engage compelling systems works",
          "state" => "in_progress",
          "result" => "no_result",
          "start_uri" => "/",
          "run_mode" => "default",
          "editable" => false,
          "browsers" => [
            {
              "id" => 2,
              "created_at" => "2014-08-22T21:09:17Z",
              "name" => "chrome",
              "result" => "failed",
              "state" => "complete"
            }
          ],
          "tags" => [],
          "steps" => [
            {
              "id" => 2,
              "created_at" => "2014-08-22T21:09:17Z",
              "test_id" => 2,
              "action" => "Click on the link fool!",
              "response" => "Did you click the link?",
              "browsers" => [
                {
                  "name" => "chrome",
                  "result" => "no_result",
                  "feedback" => []
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
      "ui_link" => "http://app.example.org/runs/28"
    }
  end

end
