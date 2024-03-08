# frozen_string_literal: true

require 'mail'
include SnapshotsHelper

class Snapshot < ApplicationRecord
  serialize :data, coder: JSON
  has_many :links

  def self.take
    connection = Postmark::ApiClient.new(Rails.application.config.x.postmark.api_token)

    # See usage docs at https://github.com/wildbit/postmark-gem
    data = connection.get_messages(offset: 0)
    data = clean_data(data)
    links = generate_links(data)

    Snapshot.new(data:, links:)
  end

  def self.clean_data(data)
    data.each do |line|
      line[:to] = line[:to].first
      line[:cc] = line[:cc].first
      line[:bcc] = line[:bcc].first
      line[:recipients] = line[:recipients].first
    end
  end

  def self.generate_links(data)
    links = []
    data.each do |message|
      links.push(Link.new(sender: extract_sender_name(message), receiver: message[:to]['Name'],
                          topic: message[:subject]))
    end
    links
  end

  def self.extract_sender_name(message)
    message[:from].match(/"([^"]+)"/)[1]
  end

  def formatted_data
    { nodes: formatted_nodes(links), links: formatted_links(links) }
  end

  def self.extract_address(address_string)
    Mail::Address.new(address_string).display_name
  end
end
