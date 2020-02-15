defmodule BldgServerWeb.BldgView do
    use BldgServerWeb, :view

    def render("index.json", %{buildings: buildings}) do
        %{
            buildings: Enum.map(buildings, &transform_bldg/1)
        }
    end

    def transform_bldg(bldg) do 
        %{
            summary: bldg.summary
            # address: bldg.address,
            # key: bldg.key
            # x: building.x,
            # y: building.y,
            # contentType: building.contentType,
            # isComposite: building.isComposite,
            # summary: building.summary,
            # picture: building.picture,
            # energy: building.energy,
            # createdAt: building.createdAt,
            # isOccupied: building.occupied,
            # occupiedBy: building.occupiedBy
        }
    end
end