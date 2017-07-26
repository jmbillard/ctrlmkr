
-- try to closes any instance of the main ui rollout...
try (destroyDialog ctrlmakerMainUi) catch()

-- includes all the templates and setup code ...
include "ctrlmaker attributes setup.ms"
include "slider with spinner ctrlmaker_attributes.ms"
include "transform spinners ctrlmaker_attributes.ms"
include "spinner ctrlmaker_attributes.ms"

struct ctrlmkrMain_source (

-- checks the attribute holder modifier...
	fn checkHolder obj holderName = (
		
		holder = EmptyModifier name:holderName

		if obj.modifiers[holderName] == undefined do addModifier $ holder
		),

	-- sets all the attribute template labels...
	fn setTemplateLabels = (

		item1 = caSliderWithSpinner_source.attributeLabel
		item2 = caTransformSpinners_source.attributeLabel
		item3 = caSpinner_source.attributeLabel

		templateLabels = #(item1, item2, item3)

		return templateLabels
		),

	-- moves selected items of a listbox by steps...
	fn moveListItems itemArray index step = (

		listArray = itemArray
		listIndex = index
		returnIndex = undefined
		newIndex = undefined

		-- restricts the first item to go up and the last to go down...
		if step >= 0 then (

			if listIndex > 1 then (

				returnIndex = listIndex - step
				newIndex = listIndex - step
				)
			else (

				returnIndex = listIndex
				newIndex = listIndex
				)
			)
		else (

			if listIndex < listArray.count then (

				returnIndex = listIndex - step
				newIndex = listIndex - step + 1
				)
			else (

				returnIndex = listIndex
				newIndex = listIndex
				)
			)

		-- changes the array...
		insertItem itemArray[index] listArray (newIndex)

		if step >= 0 then (

			deleteItem listArray (listIndex + step)
			)
		else (

			deleteItem listArray (listIndex - step - 1)
			)

		return #(listArray, returnIndex)
		),
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
	-- creates the main ui rollout...
	fn mainUi_build = (

		rollout ctrlmakerMainUi "ctrlmaker" width:210 (
			group " select template: " (
				dropdownlist ddl_attributes "" width:130 items:(ctrlmkrMain_source.setTemplateLabels()) across:2
				button btn_add "add" width:50 align:#right
				)

			group " rollout components: " (
				listbox list_caTemplates "" items:#() height:15
				label lab_num "edit rollout components:" align:#left enabled:false
				imgTag img_sep1 bitmap:(bitmap 160 1 color:(color 10 10 10)) align:#center
				button btn_up "up" width:60 align:#left
				button btn_down "down" width:60 align:#left
				button btn_del "delete selected" width:120 height:48 align:#right offset:[0,-52]
				)

			button btn_set "set properties" width:200 height:48 align:#center
			group " abaut: " (
				label lab_credit1 "ctrlmaker v3" across:2 align:#left
				hyperLink link_credit "pointlesspineapple.com" address:"https://www.pointlesspineapple.com/" align:#right
				)

			-- adds the selected template to the components list...
			on btn_add pressed do (

				newListSetup = list_caTemplates.items
				newIndex = newListSetup.count + 1

				insertItem ddl_attributes.selected newListSetup newIndex
				list_caTemplates.items = newListSetup
				list_caTemplates.selection = newIndex
				)

			-- moves the selected template up in the components list...
			on btn_up pressed do (
				if list_caTemplates.items.count >= 2 do (

					newListSetup = ctrlmkrMain_source.moveListItems list_caTemplates.items list_caTemplates.selection 1
					list_caTemplates.items = newListSetup[1]
					list_caTemplates.selection = newListSetup[2]
					)
				)

			-- moves the selected template down in the components list...
			on btn_down pressed do (

				if list_caTemplates.items.count >= 2 do (

					newListSetup = ctrlmkrMain_source.moveListItems list_caTemplates.items list_caTemplates.selection -1
					list_caTemplates.items = newListSetup[1]
					list_caTemplates.selection = newListSetup[2]
					)
				)

			-- deletes the selected template in the components list...
			on btn_del pressed do (

				newListSetup = list_caTemplates.items
				listIndex = list_caTemplates.selection
				newIndex = listIndex - 1

				if listIndex >= 1 do (

					if list_caTemplates.selection == 1 do newIndex = 1
					deleteItem newListSetup listIndex
					if newListSetup.count == 1 do newIndex = 1
					)

				list_caTemplates.items = newListSetup
				list_caTemplates.selection = newIndex
				)

			-- creates the setup ui for every template in the components list...
			on btn_set pressed do (

				ctrlmkrCaSetUp_source.setUpUi_build list_caTemplates.items
				)
			)

		createDialog ctrlmakerMainUi
		)
	)

ctrlmkrMain_source = ctrlmkrMain_source()

ctrlmkrMain_source.mainUi_build()