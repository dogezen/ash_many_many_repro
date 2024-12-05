defmodule Reproduction.Organizations do
  use Ash.Domain

  resources do
    resource Reproduction.Organizations.Organization
    resource Reproduction.Organizations.User
    resource Reproduction.Organizations.OrganizationUsers
  end
end
