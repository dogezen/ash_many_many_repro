defmodule Reproduction.Organizations.OrganizationUsers do
  use Ash.Resource,
    otp_app: :repro,
    domain: Reproduction.Organizations,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "organization_users"
    repo Reproduction.Repo
  end

  actions do
    defaults [:read, :create, :destroy]
    default_accept [:*]

    create :add_owner do
      change set_attribute(:organization_role, :owner)
    end
  end

  attributes do
    attribute :organization_role, Reproduction.Organizations.OrganizationRoles do
      allow_nil? false
      # default :user
      public? true
    end

    attribute :random, :string do
      allow_nil? true
    end

    timestamps()
  end

  relationships do
    belongs_to :user, Reproduction.Organizations.User,
      primary_key?: true,
      allow_nil?: false

    belongs_to :organization, Reproduction.Organizations.Organization,
      primary_key?: true,
      allow_nil?: false
  end
end
