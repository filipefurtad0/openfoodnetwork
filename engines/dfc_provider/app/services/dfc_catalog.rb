# frozen_string_literal: true

class DfcCatalog
  def self.load(user, catalog_url)
    api = DfcRequest.new(user)
    catalog_json = api.call(catalog_url)
    graph = DfcIo.import(catalog_json)

    new(graph)
  end

  def initialize(graph)
    @graph = graph
  end

  def products
    @products ||= @graph.select do |subject|
      subject.is_a? DataFoodConsortium::Connector::SuppliedProduct
    end
  end

  def item(semantic_id)
    @items ||= @graph.index_by(&:semanticId)
    @items[semantic_id]
  end

  def select_type(semantic_type)
    @graph.select { |i| i.semanticType == semantic_type }
  end
end
