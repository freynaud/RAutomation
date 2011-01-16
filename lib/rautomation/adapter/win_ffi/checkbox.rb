module RAutomation
  module Adapter
    module WinFfi
      class Checkbox
        include WaitHelper
        include Locators

        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        def exists?
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

        alias_method :exist?, :exists?

        # TODO: not DRY, copied from button#click
        def click
          clicked = false
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)

            @window.activate
            @window.active? &&
                    Functions.set_control_focus(hwnd) &&
                    Functions.control_click(hwnd) &&
                    clicked = true # is clicked at least once

            block_given? ? yield : clicked && exists?
          end
        end

        def checked?
          hwnd = Functions.control_hwnd(@window.hwnd, @locators)
          Functions.state_of_accessible_button hwnd
        end

      end
    end
  end
end
