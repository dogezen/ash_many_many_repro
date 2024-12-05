defmodule Reproduction.Organizations.Organization do
  use Ash.Resource,
    otp_app: :repro,
    domain: Reproduction.Organizations,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "organizations"
    repo Reproduction.Repo
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      primary? true
      accept [:name]
      argument :owner, :map, allow_nil?: false

      change manage_relationship(:owner, :users,
               type: :append,
               on_lookup: {
                 :relate,
                 :add_owner
               }
             )
    end

    update :add_member do
      require_atomic? false
      argument :user, :map, allow_nil?: false
      argument :organization_role, :atom, allow_nil?: false

      change manage_relationship(:user, :users,
               on_lookup: {:relate_and_update, :create, :read, [:organization_role]}
             )
    end
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
    many_to_many :users, Reproduction.Organizations.User do
      through Reproduction.Organizations.OrganizationUsers
      source_attribute_on_join_resource :organization_id
      destination_attribute_on_join_resource :user_id
    end

    has_many :members, Reproduction.Organizations.OrganizationUsers do
      destination_attribute :organization_id
    end
  end
end
