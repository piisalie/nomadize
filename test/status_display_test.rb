require 'test_helper'

require 'nomadize/status_display'

class StatusDisplayTest < Minitest::Test

  def setup
    @files    = [ {filename: "01_migration"}, {filename: "02_short" }]
    @records  = [ "01_migration" ]
    @display  = Nomadize::StatusDisplay.new(files: @files, records: @records)
  end

  def test_builds_a_titlebar
    titlebar = "filename     |  status"
    assert_equal titlebar, @display.titlebar
  end

  def test_divider
    size = ('01_migration' + " | " + " status").size
    divider = "-" * size
    assert_equal divider, @display.divider
  end

  def test_displays_migration_rows
    row        = "01_migration" + " | " + "     up"
    second_row = "02_short    " + " | " + "   down"

    display_rows = @display.migrations
    assert_equal row,        display_rows.next
    assert_equal second_row, display_rows.next
  end

end
