class Page < ApplicationRecord
	belongs_to :domain

	def parsed_assets
		row_assets = self.assets.present? ? JSON.parse(self[:assets].tr("'", '"')) : []
		return row_assets
	end

	def parsed__links
		row_links = self.assets.present? ? JSON.parse(self[:links].tr("'", '"')) : []
		return row_links
	end

end
