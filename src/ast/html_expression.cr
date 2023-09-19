module Mint
  class Ast
    class HtmlExpression < Node
      getter expressions

      def initialize(@expressions : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
