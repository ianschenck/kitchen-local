require_relative 'spec_helper'

describe command('echo hello') do
  its(:exit_status) { should eq 0 }
end
