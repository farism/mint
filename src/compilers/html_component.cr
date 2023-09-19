module Mint
  class Compiler
    def _compile(node : Ast::HtmlComponent) : String
      if hash = static_value(node)
        name =
          static_components_pool.of(hash, nil)

        static_components[name] ||= compile_html_component(node)

        "$#{name}()"
      else
        compile_html_component(node)
      end
    end

    def compile_html_component(node : Ast::HtmlComponent) : String
      name =
        js.class_of(lookups[node][0])

      children =
        if node.children.empty?
          ""
        else
          items =
            compile node.children, ", "

          "_array(#{items})"
        end

      attributes =
        node
          .attributes
          .map { |item| resolve(item, false) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      node.ref.try do |ref|
        attributes["ref"] = "(instance) => { this._#{ref.value} = instance }"
      end

      contents =
        [name,
         js.object(attributes),
         children]
          .reject!(&.empty?)
          .join(", ")

      "_h(#{contents})"
    end
  end
end
