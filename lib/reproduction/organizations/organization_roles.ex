defmodule Reproduction.Organizations.OrganizationRoles do
  use Ash.Type.Enum, values: [:owner, :admin, :user, :patient]
end
