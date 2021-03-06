require 'spec_helper'

module Landable
  module Public
    module Preview
      describe PagesController do
        routes { Landable::Engine.routes }

        describe '#show' do
          let(:page) { create :page, body: '<p>hello</p>' }

          before(:each) do
            page.publish! author: create(:author)
            page.update_attributes! body: '<p>why hello there</p>'
          end

          def make_request
            get :show, id: page.id
          end

          it 'renders the page in situ' do
            make_request
            expect(response.body).to include '<p>why hello there</p>'
          end

          it 'renders the preview message' do
            make_request
            expect(response.body).to include 'Preview Mode'
          end

          it 'is available at /-/p/:id' do
            assert_recognizes({ controller: 'landable/public/preview/pages', action: 'show', id: page.id }, "/-/p/#{page.id}")
          end
        end
      end
    end
  end
end
