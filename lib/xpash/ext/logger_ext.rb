require 'logger'

class Logger

  def debug_var(ctx, *vars)
    class_name = ctx.eval("self.class").to_s
    if class_name != "Class"
      sep = "#"
    else
      class_name = ctx.eval("self.name")
      sep = "."
    end

    /^(.+?):(\d+)(?::in `(.*)')?/.match(caller.first)
    method_name = $3 ? $3 : ""

    message_a = vars.map {|var|
      "\n" + yellow(var.to_s) + " => " + yellow(ctx.eval(var.to_s).inspect)
    }

    debug(class_name + sep + method_name) { message_a.join(", ") }
  end

end
