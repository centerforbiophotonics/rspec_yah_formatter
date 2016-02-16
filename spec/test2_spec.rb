require 'rspec'

def fake_screenshot(metadata)
  filename = File.basename(metadata[:file_path])
  line_number = metadata[:line_number]
  FileUtils.mkdir 'screenshots' unless File.exist? 'screenshots'
  screenshot_name = "screenshots/#{filename}-#{line_number}.png"
  FileUtils.cp(File.join(__dir__, 'something.png'), screenshot_name)
  screenshot_name
end

RSpec.configure do |config|
  config.after(:each) do |example|
    if example.exception
      screenshot_name = fake_screenshot(example.metadata)
      example.metadata[:screenshot] = screenshot_name
    end
  end
end

describe 'The second Test' do
  it 'should do cool test stuff' do
    pending('coming soon')
    fail
  end

  it 'should do amazing test stuff' do
    expect('boats').to eq 'boats'
  end

  it 'should do superb test stuff' do
    expect('ships').to eq 'ships'
  end

  it 'should do example stuff' do
    expect('apple').to eq 'apple'
    expect('pear').to eq 1
  end

  it 'should do very cool test stuff' do
    expect('cars').to eq 'cars'
    expect('diesel').to eq 'diesels'
    expect('apple').to eq 'apple'
  end

  it 'should do very amazing test stuff' do
    expect('boats').to eq 'boats'
  end

  it 'should do very superb test stuff' do
    expect('ships').to eq 'ships'
  end

  it 'should do very rawesome test stuff' do
    pending('give me a woop')
    fail
  end

  it 'should do insane and cool test stuff' do
    expect('ships').to eq 'ships'
  end
end
