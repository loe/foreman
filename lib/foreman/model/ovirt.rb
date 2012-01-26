module Foreman::Model
  class Ovirt < ComputeResource
    before_save :fetch_uuid

    def class
      ComputeResource
    end

    #FIXME
    def max_cpu_count
      8
    end

    def max_memory
      16*1024*1024
    end

    def hardware_profiles
      client.templates.all(:search => 'name=hwp_*')
    end

    def destroy_vm uuid
      client.destroy_vm(uuid)
    end

    protected

    def client
      @client ||= ::Fog::Compute.new(
        :provider => "ovirt",
        :ovirt_username => user,
        :ovirt_password => password,
        :ovirt_url => url,
        :ovirt_datacenter => uuid
      )
    end

    def vm_instance_defaults
      if @hardware_profile
        client.templates.get(@hardware_profile)
      else
        {
          :name => 'vm-'+Time.now.to_i.to_s,
          :cluster_name => 'test',
          :template_name => 'Blank'
        }
      end
    end

    private

    def fetch_uuid
      filter = name.blank? ? "" : ("name=%s" % name)
      client = ::Fog::Compute.new(
        :provider => "ovirt",
        :ovirt_username => user,
        :ovirt_password => password,
        :ovirt_url => url)
        datacenters = client.datacenters(:search=>filter)

        if datacenters.empty?
          errors.add(:base, "Datacenter #{name} not found")
          false
        else
          self.uuid = datacenters.first.id
        end
    rescue => e
      errors.add(:base, e.message)
      false
    end

  end
end
