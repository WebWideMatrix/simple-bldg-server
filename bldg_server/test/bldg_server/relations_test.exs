defmodule BldgServer.RelationsTest do
  use BldgServer.DataCase

  alias BldgServer.Relations

  describe "roads" do
    alias BldgServer.Relations.Road

    @valid_attrs %{flr: "some flr", from_address: "some from_address", to_address: "some to_address"}
    @update_attrs %{flr: "some updated flr", from_address: "some updated from_address", to_address: "some updated to_address"}
    @invalid_attrs %{flr: nil, from_address: nil, to_address: nil}

    def road_fixture(attrs \\ %{}) do
      {:ok, road} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Relations.create_road()

      road
    end

    test "list_roads/0 returns all roads" do
      road = road_fixture()
      assert Relations.list_roads() == [road]
    end

    test "get_road!/1 returns the road with given id" do
      road = road_fixture()
      assert Relations.get_road!(road.id) == road
    end

    test "create_road/1 with valid data creates a road" do
      assert {:ok, %Road{} = road} = Relations.create_road(@valid_attrs)
      assert road.flr == "some flr"
      assert road.from_address == "some from_address"
      assert road.to_address == "some to_address"
    end

    test "create_road/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Relations.create_road(@invalid_attrs)
    end

    test "update_road/2 with valid data updates the road" do
      road = road_fixture()
      assert {:ok, %Road{} = road} = Relations.update_road(road, @update_attrs)
      assert road.flr == "some updated flr"
      assert road.from_address == "some updated from_address"
      assert road.to_address == "some updated to_address"
    end

    test "update_road/2 with invalid data returns error changeset" do
      road = road_fixture()
      assert {:error, %Ecto.Changeset{}} = Relations.update_road(road, @invalid_attrs)
      assert road == Relations.get_road!(road.id)
    end

    test "delete_road/1 deletes the road" do
      road = road_fixture()
      assert {:ok, %Road{}} = Relations.delete_road(road)
      assert_raise Ecto.NoResultsError, fn -> Relations.get_road!(road.id) end
    end

    test "change_road/1 returns a road changeset" do
      road = road_fixture()
      assert %Ecto.Changeset{} = Relations.change_road(road)
    end
  end
end
