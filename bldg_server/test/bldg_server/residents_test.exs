defmodule BldgServer.ResidentsTest do
  use BldgServer.DataCase

  alias BldgServer.Residents

  describe "residents" do
    alias BldgServer.Residents.Resident

    @valid_attrs %{alias: "some alias", direction: 42, email: "some email", home_bldg: "some home_bldg", is_online: true, last_login_at: ~N[2010-04-17 14:00:00], location: "some location", name: "some name", other_attributes: %{}, previous_messages: [], session_id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{alias: "some updated alias", direction: 43, email: "some updated email", home_bldg: "some updated home_bldg", is_online: false, last_login_at: ~N[2011-05-18 15:01:01], location: "some updated location", name: "some updated name", other_attributes: %{}, previous_messages: [], session_id: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{alias: nil, direction: nil, email: nil, home_bldg: nil, is_online: nil, last_login_at: nil, location: nil, name: nil, other_attributes: nil, previous_messages: nil, session_id: nil}

    def resident_fixture(attrs \\ %{}) do
      {:ok, resident} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Residents.create_resident()

      resident
    end

    test "list_residents/0 returns all residents" do
      resident = resident_fixture()
      assert Residents.list_residents() == [resident]
    end

    test "get_resident!/1 returns the resident with given id" do
      resident = resident_fixture()
      assert Residents.get_resident!(resident.id) == resident
    end

    test "create_resident/1 with valid data creates a resident" do
      assert {:ok, %Resident{} = resident} = Residents.create_resident(@valid_attrs)
      assert resident.alias == "some alias"
      assert resident.direction == 42
      assert resident.email == "some email"
      assert resident.home_bldg == "some home_bldg"
      assert resident.is_online == true
      assert resident.last_login_at == ~N[2010-04-17 14:00:00]
      assert resident.location == "some location"
      assert resident.name == "some name"
      assert resident.other_attributes == %{}
      assert resident.previous_messages == []
      assert resident.session_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_resident/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Residents.create_resident(@invalid_attrs)
    end

    test "update_resident/2 with valid data updates the resident" do
      resident = resident_fixture()
      assert {:ok, %Resident{} = resident} = Residents.update_resident(resident, @update_attrs)
      assert resident.alias == "some updated alias"
      assert resident.direction == 43
      assert resident.email == "some updated email"
      assert resident.home_bldg == "some updated home_bldg"
      assert resident.is_online == false
      assert resident.last_login_at == ~N[2011-05-18 15:01:01]
      assert resident.location == "some updated location"
      assert resident.name == "some updated name"
      assert resident.other_attributes == %{}
      assert resident.previous_messages == []
      assert resident.session_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_resident/2 with invalid data returns error changeset" do
      resident = resident_fixture()
      assert {:error, %Ecto.Changeset{}} = Residents.update_resident(resident, @invalid_attrs)
      assert resident == Residents.get_resident!(resident.id)
    end

    test "delete_resident/1 deletes the resident" do
      resident = resident_fixture()
      assert {:ok, %Resident{}} = Residents.delete_resident(resident)
      assert_raise Ecto.NoResultsError, fn -> Residents.get_resident!(resident.id) end
    end

    test "change_resident/1 returns a resident changeset" do
      resident = resident_fixture()
      assert %Ecto.Changeset{} = Residents.change_resident(resident)
    end
  end
end
