defmodule Reproduction.Organizations.User do
  use Ash.Resource,
    otp_app: :repro,
    domain: Reproduction.Organizations,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo Reproduction.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
    default_accept [:*]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    many_to_many :organizations, Reproduction.Organizations.Organization do
      through Reproduction.Organizations.OrganizationUsers
      source_attribute_on_join_resource :user_id
      destination_attribute_on_join_resource :organization_id
    end

    has_many :organization_memberships, Reproduction.Organizations.OrganizationUsers do
      destination_attribute :user_id
    end
  end
end
