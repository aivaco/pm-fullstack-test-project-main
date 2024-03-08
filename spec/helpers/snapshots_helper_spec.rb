# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnapshotsHelper, type: :helper do
  let(:links) do
    [
      Link.new(sender: 'Sender1', receiver: 'Receiver1', topic: 'Topic1'),
      Link.new(sender: 'Sender2', receiver: 'Receiver1', topic: 'Topic2'),
      Link.new(sender: 'Sender1', receiver: 'Receiver2', topic: 'Topic3'),
      Link.new(sender: 'Sender1', receiver: 'Receiver2', topic: 'Topic4')
    ]
  end

  describe '#formatted_nodes' do
    it 'returns formatted nodes' do
      formatted_nodes = formatted_nodes(links)
      expect(formatted_nodes).to match_array([{ id: 'Sender1' }, { id: 'Sender2' }, { id: 'Receiver1' },
                                              { id: 'Receiver2' }])
    end
  end

  describe '#formatted_links' do
    it 'returns formatted links' do
      formatted_links = formatted_links(links)

      expect(formatted_links).to match_array([
                                               { source: 'Sender1', target: 'Receiver1', topics: ['Topic1'] },
                                               { source: 'Sender1', target: 'Receiver2', topics: %w[Topic3 Topic4] },
                                               { source: 'Sender2', target: 'Receiver1', topics: ['Topic2'] }
                                             ])
    end
  end
end
