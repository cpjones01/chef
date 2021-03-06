#
# Copyright:: Copyright 2016-2017, Chef Software Inc.
# License:: Apache License, Version 2.0
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

require "chef/resource/user"

class Chef
  class Resource
    class User
      class WindowsUser < Chef::Resource::User
        resource_name :windows_user

        provides :windows_user
        provides :user, os: "windows"

        property :full_name, String,
                  description: "The full name of the user.",
                  introduced: "14.6"
      end
    end
  end
end
