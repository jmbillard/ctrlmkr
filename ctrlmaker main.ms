
-- try to closes any instance of the rollout floaters...
try (closeRolloutFloater ctrlmkrMain_source.ctrlmkrFloater) catch()
try (closeRolloutFloater ctrlmkrCaSetUp_source.setUpFloater) catch()

-- includes the custom attributes setup code ...
include "ctrlmaker attributes setup.ms"

struct ctrlmkrMain_source (

	ctrlmkrFloater = undefined,

	-- sets all the attribute template labels...
	fn setTemplateLabels = (

		item1 = caSlider_source.attributeLabel
		item2 = caSpinner_source.attributeLabel
		item3 = caSliderWithSpinner_source.attributeLabel
		item4 = caTransformSpinners_source.attributeLabel

		templateLabels = #(item1, item2, item3, item4)

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

	fn getCaName obj modIndex caList = (

		caCount = custAttributes.count obj.modifiers[modIndex]

		for i in 1 to caCount do (

			caDef = (custAttributes.getDef obj.modifiers[modIndex] i)
			caName = ((custAttributes.getPBlockDefs caDef)[1])[1] as string
			append caList caName
			)

		return caList
		),

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
	-- creates the main ui rollout...
	fn mainUi_build = (

		ctrlmkrMain_source.ctrlmkrFloater = newRolloutFloater "ctrlmkr..." 220 499

		rollout templateListUi "template list setup" width:210 (

			group " custom attribute template: " (

				dropdownlist ddl_attributes "" width:150 \
				items:(ctrlmkrMain_source.setTemplateLabels()) across:2
				button btn_add "+" width:30 align:#right
				)

			group " rollout components: " (

				listbox list_caTemplates "" items:#() height:10
				button btn_up "up" width:60 align:#left across:3
				button btn_down "down" width:60 align:#center
				button btn_del "delete" width:60 align:#right --
				imgTag img_sep2 bitmap:(bitmap 180 1 color:(color 10 10 10)) align:#center
				colorpicker tag_color1 "" color:(random (color 0 0 0) (color 255 255 255)) \
				width:65 height:18 align:#left across:3 offset:[-3, 0]
				label lab_color "<>" align:#center offset:[0, 2]
				colorpicker tag_color2 "" color:(random (color 0 0 0) (color 255 255 255)) \
				width:65 height:18 align:#right
				)

			button btn_set "custom attributes setup" width:200 align:#center

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

					listArray = list_caTemplates.items
					index = list_caTemplates.selection

					newListSetup = ctrlmkrMain_source.moveListItems listArray index 1
					
					list_caTemplates.items = newListSetup[1]
					list_caTemplates.selection = newListSetup[2]
					)
				)

			-- moves the selected template down in the components list...
			on btn_down pressed do (

				if list_caTemplates.items.count >= 2 do (

					listArray = list_caTemplates.items
					index = list_caTemplates.selection

					newListSetup = ctrlmkrMain_source.moveListItems listArray index -1
					
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

				listArray = list_caTemplates.items
				wPos = ctrlmkrMain_source.ctrlmkrFloater.pos

				if listArray.count != 0 then (

				
					color1 = tag_color1.color
					color2 = tag_color2.color

					ctrlmkrCaSetUp_source.setUpUi_build wPos listArray color1 color2
					)

				else messageBox "(づ｡◕‿‿◕｡)づ     add some templates!" \
				title:"ERROR: 4434814-7  ||  EVERYTHING IS CRASHING BY"
				)
			)

		rollout infoUi "info" width:210 (

			group " abaut: " (

				label lab_credit1 "ctrlmaker v3" align:#left across:2
				hyperLink link_credit "pointlesspineapple.com" \
				address:"https://www.pointlesspineapple.com/" align:#right
				)
			)

		rollout editCaUi "manege custom attributes" width:210 (

			group " definitions: " (

				listbox list_def "" items:#() height:4
				--button btn_copy "copy" width:60 align:#left across:3
				--button btn_paste "paste" width:60 align:#center
				--button btn_print "print" width:60 align:#right --
				)

			button btn_del "delete attribute definition" width:200 align:#center

			fn refreshDefList = (

				defList = #()

				if (selection as array).count == 1 and $.modifiers[1] != undefined do (

					modIndex = modPanel.getModifierIndex $ (modPanel.getCurrentObject())
					defList = ctrlmkrMain_source.getCaName $ modIndex defList
					)

				list_def.items = defList
				)

			fn deleteDef = (

				if (selection as array).count == 1 and $.modifiers[1] != undefined do (

					modIndex = modPanel.getModifierIndex $ (modPanel.getCurrentObject())
					custAttributes.delete $.modifiers[modIndex] list_def.selection
					)

				refreshDefList()
				)

			on list_def rightClick do (

				refreshDefList()
				)

			on btn_del pressed do (

				deleteDef()
				)
			)

		addRollout templateListUi ctrlmkrMain_source.ctrlmkrFloater
		addRollout editCaUi ctrlmkrMain_source.ctrlmkrFloater
		addRollout infoUi ctrlmkrMain_source.ctrlmkrFloater rolledUp:true
		)
	)

ctrlmkrMain_source = ctrlmkrMain_source()

ctrlmkrMain_source.mainUi_build()