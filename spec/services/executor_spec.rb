RSpec.describe Executor do
  let(:database)   { Database.new(DB) }
  let(:service)    { Executor.new(database) }

  describe 'executor actions' do
    let(:product)    { { 'name'=>'Coca Cola', 'price'=>2.0 } }

    it 'counts full balance' do
      expect(service.machine_balance).to eq(DB.fetch('banknotes').map { |k, v| k * v }.sum)
    end

    it 'returns all products' do
      expect(service.machine_products).to eq(DB.fetch('products'))
    end

    context 'when machine product present' do
      let(:option) { { 'quantity' => 2 } }

      it 'returns true' do
        expect(service.is_quantity_positive?(product.merge(option))).to eq(true)
      end
    end

    context 'when machine product absent' do
      let(:option) { { 'quantity' => 0 } }

      it 'returns false' do
        expect(service.is_quantity_positive?(product.merge(option))).to eq(false)
      end
    end
  end

  describe '#recount_money' do
    context 'when balance is positive' do
      context 'when the rest responds to database' do

        it 'returns full change' do
          allow(service).to receive(:machine_banknotes).and_return({ 5.0=>5, 4.0=>5, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>5 })

          expect {
            service.recount_change(33)
          }.to change { service.machine_banknotes }.from(service.machine_banknotes).to({ 5.0=>0, 4.0=>3, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>5 })
        end
      end

      context 'when the rest responds to database' do
        it 'returns not full change' do
          allow(service).to receive(:machine_banknotes).and_return({ 5.0=>3, 4.0=>5, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>5 })

          expect {
            service.recount_change(33.21)
          }.to change { service.machine_banknotes }.from(service.machine_banknotes).to({ 5.0=>0, 4.0=>1, 3.0=>5, 2.0=>4, 1.0=>5, 0.5=>5, 0.25=>5 })
        end
      end
    end

    context 'when balance is negative' do
      it 'will take all money from bank account' do
        allow(service).to receive(:machine_banknotes).and_return({ 5.0=>0, 4.0=>0, 3.0=>0, 2.0=>0, 1.0=>2, 0.5=>1, 0.25=>2 })

        expect {
          service.recount_change(5)
        }.to change { service.machine_banknotes }.from(service.machine_banknotes).to({ 5.0=>0, 4.0=>0, 3.0=>0, 2.0=>0, 1.0=>0, 0.5=>0, 0.25=>0 })
      end
    end
  end
end
