defmodule ReproTest do
  use Reproduction.DataCase

  describe "organization" do
    test "can add member" do
      # create user
      user =
        Reproduction.Organizations.User
        |> Ash.Changeset.for_create(:create, %{name: "user_name"})
        |> Ash.create!()

      assert user.name == "user_name"

      # create org owner
      owner =
        Reproduction.Organizations.User
        |> Ash.Changeset.for_create(:create, %{name: "owner_name"})
        |> Ash.create!()

      assert owner.name == "owner_name"

      # create organisation
      org =
        Reproduction.Organizations.Organization
        |> Ash.Changeset.for_create(:create, %{name: "org_name", owner: owner})
        |> Ash.create!()
        |> Ash.load!(:members)

      assert org.name == "org_name"
      assert length(org.members) == 1
      assert hd(org.members).user_id == owner.id
      assert hd(org.members).organization_role == :owner

      # attempt to add user to organisation as an admin
      {outcome, data} =
        org
        |> Ash.Changeset.for_update(:add_member, %{
          user: Map.put(user, :organization_role, :admin),
          organization_role: :admin
        })
        |> Ash.update()

      IO.inspect(data)
      assert :ok == outcome
    end
  end
end
