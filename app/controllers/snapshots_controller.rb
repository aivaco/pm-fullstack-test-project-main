class SnapshotsController < ApplicationController
  def show
    @snapshot = Snapshot.last.formatted_data
  end
end
