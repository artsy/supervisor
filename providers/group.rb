#
# Author:: Gilles Devaux <gilles.devaux@gmail.com>
# Cookbook Name:: supervisor
# Provider:: group
#
# Copyright:: 2011, Formspring.me
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :enable do
  converge_by("Enabling #{ new_resource }") do
    execute "supervisorctl update" do
      action :nothing
      user "root"
    end

    template "#{node['supervisor']['dir']}/#{new_resource.group_name}.conf" do
      source "group.conf.erb"
      cookbook "supervisor"
      owner "root"
      group "root"
      mode "644"
      variables :prog => new_resource
      notifies :run, "execute[supervisorctl update]", :immediately
    end
  end
end

action :disable do
  converge_by("Disabling #{ new_resource }") do
    execute "supervisorctl update" do
      action :nothing
      user "root"
    end

    file "#{node['supervisor']['dir']}/#{new_resource.group_name}.conf" do
      action :delete
      notifies :run, "execute[supervisorctl update]", :immediately
    end
  end
end

action :start do
  converge_by("Starting #{ new_resource }") do
    execute "supervisorctl start #{new_resource.group_name}:*" do
      user "root"
    end
  end
end

action :stop do
  converge_by("Stopping #{ new_resource }") do
    execute "supervisorctl stop #{new_resource.group_name}:*" do
      user "root"
    end
  end
end

action :restart  do
  converge_by("Restarting #{ new_resource }") do
    Chef::Log.info "Running 'supervisorctl restart #{new_resource.group_name}:*'"
    execute "supervisorctl restart #{new_resource.group_name}:*" do
      user "root"
    end
  end
end

action :reload  do
  converge_by("Reloading #{ new_resource }") do
    execute "supervisorctl restart #{new_resource.group_name}:*" do
      user "root"
    end
  end
end
