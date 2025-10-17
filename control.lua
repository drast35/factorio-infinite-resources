original_resource_type = prototypes.mod_data["original-resource-type"]["data"]

function fix_resources_for_surface(surface, area)
    resources = surface.find_entities_filtered{
        area = area,
        type = 'resource',
    }
    for _, resource in pairs(resources) do
        if resource.prototype.infinite_resource then
            -- set all new resources to exactly their normal amount
			-- only set resources which were not originally infinite to their normal amount.
			if (not original_resource_type[resource.prototype.name]) then
				resource.initial_amount = resource.prototype.normal_resource_amount
				resource.amount = resource.prototype.normal_resource_amount
			end
        end
    end
end

script.on_configuration_changed(function()
    for _, surface in pairs(game.surfaces) do
        fix_resources_for_surface(surface)
    end
end)

script.on_event(defines.events.on_chunk_generated, function(event)
    fix_resources_for_surface(event.surface, event.area)
end)

script.on_event(defines.events.on_surface_created, function(event)
    fix_resources_for_surface(game.surfaces[event.surface_index])
end)
