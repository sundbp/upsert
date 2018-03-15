class Upsert
  # @private
  class Connection
    attr_reader :controller
    attr_reader :metal

    def initialize(controller, metal)
      @controller = controller
      @metal = metal
    end

    def convert_binary(bind_values)
      bind_values.map do |v|
        case v
        when Upsert::Binary
          binary v
        else
          v
        end
      end
    end

    def jdbc?
      puts metal
      puts metal.class.name
      raise "boom!"
    end

    def bind_value(v)
      case v
      # when Time, DateTime
      #   if jdbc?
      #     v
      #   else
      #     Upsert.utc_iso8601 v
      #   end
      # when Date
      #   if jdbc?
      #     v
      #   else
      #     v.strftime ISO8601_DATE
      #   end
      when Symbol
        v.to_s
      else
        v
      end
    end

  end
end
