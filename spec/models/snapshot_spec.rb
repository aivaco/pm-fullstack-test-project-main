# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  describe '.take' do
    it 'creates a new Snapshot with data and links' do
      allow(Postmark::ApiClient).to receive(:new).and_return(
        double(get_messages: [{ message_id: 'ee20114e-c5f6-4c9f-b91f-ed0276c7f8bc',
                                message_stream: 'outbound',
                                to: [{
                                  'Email' => 'anything@blackhole.postmarkapp.com',
                                  'Name' => 'Duncan Collins'
                                }],
                                cc: [],
                                bcc: [],
                                recipients: ['anything@blackhole.postmarkapp.com'],
                                received_at: '2024-02-21T16:44:59-05:00',
                                from: '"Fr. Portia Dach" <anything@blackhole.postmarkapp.com>',
                                subject: 'ActiveCampaign',
                                attachments: [],
                                status: 'Sent',
                                track_links: 'None',
                                metadata: {},
                                sandboxed: false }])
      )
      snapshot = Snapshot.take

      expect(snapshot).to be_a(Snapshot)
      expect(snapshot.data).to be_present
      expect(snapshot.links).to be_present
    end
  end

  describe '.clean_data' do
    it 'cleans the data received' do
      data = [{ to: ['to1'], cc: ['cc1'], bcc: ['bcc1'], recipients: ['recipients1'] }]
      cleaned_data = Snapshot.clean_data(data)

      expect(cleaned_data).to eq([{ to: 'to1', cc: 'cc1', bcc: 'bcc1', recipients: 'recipients1' }])
    end
  end

  describe '.generate_links' do
    it 'generates links from data' do
      data = [{ from: '"Fr. Portia Dach" <anything@blackhole.postmarkapp.com>', to: { 'Name' => 'Duncan Collins' },
                subject: 'ActiveCampaign' }]
      links = Snapshot.generate_links(data)

      expect(links.first).to be_a(Link)
      expect(links.first.sender).to eq('Fr. Portia Dach')
      expect(links.first.receiver).to eq('Duncan Collins')
      expect(links.first.topic).to eq('ActiveCampaign')
    end
  end

  describe '.extract_sender_name' do
    it 'extracts sender name from message' do
      message = { from: '"Sender Name" <sender@example.com>' }
      sender_name = Snapshot.extract_sender_name(message)

      expect(sender_name).to eq('Sender Name')
    end
  end

  describe '#formatted_data' do
    it 'returns formatted data with nodes and links' do
      snapshot = Snapshot.new
      allow(snapshot).to receive(:formatted_nodes).and_return([])
      allow(snapshot).to receive(:formatted_links).and_return([])

      formatted_data = snapshot.formatted_data

      expect(formatted_data).to eq({ nodes: [], links: [] })
    end
  end

  describe '.extract_address' do
    it 'extracts display name from address string' do
      address_string = '"John Doe" <john@example.com>'
      display_name = Snapshot.extract_address(address_string)

      expect(display_name).to eq('John Doe')
    end
  end
end
