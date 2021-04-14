require 'minitest/spec'

describe 'ebs::volumes::libraries' do
  it "should detect EBS volumes on Ubuntu 14.04" do
    # on ubuntu mn:Amazon Elastic Block is returned
    # rather than the more correct Amazon Elastic Block Store

    lines = <<EOF
NVME Identify Controller:
   vid     : 0x1d0f
   ssvid   : 0x1d0f
   sn      : vol03ad072723a6e3595
   mn      : Amazon Elastic Block
   fr      : 1.0
   rab     : 32
   ieee    : dc02a0
   cmic    : 0
EOF

    nvme_ctrl_double = double("shellout_double")
    allow(nvme_ctrl_double).to receive(:run_command)
    allow(nvme_ctrl_double).to receive(:error!)
    allow(nvme_ctrl_double).to receive(:stdout).and_return(lines)

    allow(Mixlib::ShellOut).to receive(:new).with("/usr/sbin/nvme id-ctrl /dev/nvme0n1").and_return(nvme_ctrl_double)

    allow(File).to receive(:executable?).and_return(false)

    expect(EbsVolume.volume_id("/dev/nvme0n1")).to eq("vol-03ad072723a6e3595")
  end

  it "detect EBS volumes on non-Ubuntu 14.04" do
    lines = <<EOF
NVME Identify Controller:
   vid     : 0x1d0f
   ssvid   : 0x1d0f
   sn      : vol03ad072723a6e3595
   mn      : Amazon Elastic Block Store
   fr      : 1.0
   rab     : 32
   ieee    : dc02a0
   cmic    : 0
EOF

    nvme_ctrl_double = double("shellout_double")
    allow(nvme_ctrl_double).to receive(:run_command)
    allow(nvme_ctrl_double).to receive(:error!)
    allow(nvme_ctrl_double).to receive(:stdout).and_return(lines)

    allow(Mixlib::ShellOut).to receive(:new).with("/usr/sbin/nvme id-ctrl /dev/nvme0n1").and_return(nvme_ctrl_double)

    allow(File).to receive(:executable?).and_return(false)

    expect(EbsVolume.volume_id("/dev/nvme0n1")).to eq("vol-03ad072723a6e3595")
  end

end
