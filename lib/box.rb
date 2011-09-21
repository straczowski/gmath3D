require 'gmath3D'

module GMath3D
  class Box < Geom
public
    attr_accessor :min_point
    attr_accessor :max_point

    def initialize(point1 = Vector3.new(0,0,0), point2 = Vector3.new(1,1,1))
      Util.check_arg_type(Vector3, point1)
      Util.check_arg_type(Vector3, point2)
      super()
      @min_point = Vector3.new();
      @max_point = Vector3.new();
      @min_point.x = [ point1.x, point2.x ].min
      @min_point.y = [ point1.y, point2.y ].min
      @min_point.z = [ point1.z, point2.z ].min
      @max_point.x = [ point1.x, point2.x ].max
      @max_point.y = [ point1.y, point2.y ].max
      @max_point.z = [ point1.z, point2.z ].max
    end

    def ==(rhs)
      equals_inner(rhs)
    end
    def +(rhs)
      add(rhs)
    end

    def center
      return (@min_point + @max_point) * 0.5
    end

    def length
      return max_point.x - min_point.x, max_point.y - min_point.y, max_point.z - min_point.z
    end

    def volume
      width, height, depth = self.length
      return width*height*depth
    end

private
    def equals_inner(rhs)
      return false if( !rhs.kind_of?(Box) )
      return false if(self.min_point != rhs.min_point)
      return false if(self.max_point != rhs.max_point)
      true
    end
    def add(rhs)
      if( rhs.kind_of?(Vector3))
        added_box = Box.new()
        added_box.min_point.x = [ self.min_point.x, rhs.x ].min
        added_box.min_point.y = [ self.min_point.y, rhs.y ].min
        added_box.min_point.z = [ self.min_point.z, rhs.z ].min
        added_box.max_point.x = [ self.max_point.x, rhs.x ].max
        added_box.max_point.y = [ self.max_point.y, rhs.y ].max
        added_box.max_point.z = [ self.max_point.z, rhs.z ].max
        return added_box
      elsif( rhs.kind_of?(Box))
        min_max_point_ary = [rhs.min_point, rhs.max_point]
        return self + min_max_point_ary
      elsif(rhs.kind_of?(Array))
        added_box = self;
        rhs.each do |item|
          added_box = added_box + item
        end
        return added_box
      end
      Util.raise_argurment_error(rhs)
    end
  end
end
