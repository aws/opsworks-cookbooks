require 'spec_helper'

describe file('/root/kitchen-test') do
  it { should be_file }
end
