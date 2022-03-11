require 'rails_helper'

RSpec.describe WeatherGetter do

  let(:response) { 'good json response with weather data' }
  let(:http_error_response) { 'http error' }
  let(:options) { {test: 'paramValue'} }

  subject { described_class }

  describe '#call' do
    context 'good weather response not cached' do
      before do
        allow(CacheManager).to receive(:get_value).and_return response
        allow(CacheManager).to receive(:exist_in_cache?).and_return false
      end

      it 'returns the weather data' do
        data = subject.call(:searchKey, "searchValue", options)
        expect(data.success?).to be true
        expect(data.result).to be response
        expect(data.cache_data?).to be false
      end
    end

    context 'good weather response cached' do
      before do
        allow(CacheManager).to receive(:get_value).and_return response
        allow(CacheManager).to receive(:exist_in_cache?).and_return true
      end

      it 'returns the weather data' do
        data = subject.call(:searchKey, "searchValue", options)
        expect(data.success?).to be true
        expect(data.result).to be response
        expect(data.cache_data?).to be true
        expect(data.error).to be nil
      end
    end

    context 'no search params' do
      it 'should return just a success?=true without trying to pull data' do
        data = subject.call(:zip, "", options)
        expect(data.success?).to be false
        expect(data.result).to be nil
      end
    end

    context 'http error response' do
      before do
        allow(CacheManager).to receive(:get_value).and_raise http_error_response
      end

      it 'returns the weather data' do
        data = subject.call(:searchKey, "searchValue", options)
        expect(data.success?).to be false
        expect(data.result).to be nil
        expect(data.error).to be http_error_response
      end
    end
  end
end