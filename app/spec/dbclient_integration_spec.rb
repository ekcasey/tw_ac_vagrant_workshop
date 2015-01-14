require 'spec_helper'

describe DBClient do

  before do
    @client = DBClient.new
    truncate
  end

  it 'should show all minions' do
    insert_seed
    result = @client.show_all
    expect(result.count).to eq(2)
    expect(result[0][:name]).to include('carl')
    expect(result[1][:name]).to include('jill')
  end

  it 'should insert minion' do

    @client.insert('carl')

    result = @client.show_all
    expect(result[0][:name]).to include('carl')
    expect(result.count).to eq(1)
  end

  it 'should delete minion' do
    insert_seed
    @client.delete(1)

    result = @client.show_all
    expect(result.count).to eq(1)
    expect(result[0][:name]).to include('jill')

  end

  def insert_seed
    stmt = @client.client.prepare("insert into minions(name) values ('carl')")
    stmt.execute
    stmt = @client.client.prepare("insert into minions(name) values ('jill')")
    stmt.execute
    stmt.close
  end

  after(:all) do
    @client = DBClient.new
    truncate
  end

  def truncate
    stmt = @client.client.prepare('truncate table minions')
    stmt.execute
    stmt.close
  end


end