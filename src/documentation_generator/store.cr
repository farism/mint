module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Store, json : JSON::Builder)
      json.object do
        json.field "name" do
          generate node.name, json
        end

        json.field "description", node.comment.try(&.to_html)

        json.field "states" do
          generate node.states, json
        end

        json.field "computed-properties" do
          generate node.gets, json
        end

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Store)
      render("#{__DIR__}/html/store.ecr")
    end

    def stringify(node : Ast::Store)
      node.name.value
    end

    def children(node : Ast::Store)
      children("stores", "state", node, node.states) |
        children("stores", "function", node, node.functions)
    end
  end
end
