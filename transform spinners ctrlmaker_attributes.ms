struct caTransformSpinners_source (

	-- contains the item label for the main ui...
	attributeLabel = "transform spinners xyz",

	-- contains the strings to setup the custom attributes...
	fn setUpUiPrp iS = (

		range1 = "[-99999999999, 99999999999, -9999]"
		range2 = "[-99999999999, 99999999999, 9999]"
		setPropGrp = \
			"group \" transform spinners xyz: \" (\n"+\
			"radioButtons rdo_trm" + iS + " \"\" labels:#(\"pos\",\"rot\",\"scale\") align:#left columns:1 offset:[0,0]\n" +\
			-----------------------------------------------------------------------------------------------------
			"imgTag img_" + iS + "X bitmap:(bitmap 2 12 color:red) align:#center offset:[-34,-49]\n"+\
			"spinner ui_spnX_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnX_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			-----------------------------------------------------------------------------------------------------
			"imgTag img_" + iS + "Y bitmap:(bitmap 2 12 color:green) align:#center offset:[-34,-2]\n"+\
			"spinner ui_spnY_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnY_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			-----------------------------------------------------------------------------------------------------
			"imgTag img_" + iS + "Z bitmap:(bitmap 2 12 color:blue) align:#center offset:[-34,-2]\n"+\
			"spinner ui_spnZ_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnZ_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n)\n"

		return setPropGrp
		),

	-- contains the strings for the custom attributes rollout...
	fn caParamUi uiIndex rollName minArray maxArray propIndex = (

		iS = uiIndex as string
		trm = #("position", "rotation", "scale"); tProp = trm[propIndex]
		colorArray = #("red", "green", "blue"); axisArray = #("X", "Y", "Z")
		caParam = ""
		caUi = "group \" " + tProp + ": \" (\n"

		for i in 1 to 3 do (
			
			defValueS = ((minArray[i] + maxArray[i]) / 2) as string
			if tProp == "scale" do defValueS = "1"
			range = "[" + minArray[i] as string + "," + maxArray[i] as string + "," + defValueS + "]"
			
			-- sets the parameter block...
			caParam +=
				"'trs_" + iS + "_" + tProp + axisArray[i] + "' type:#float "+\
				"default:" + defValueS + " ui:(trs_spn_" + tProp + axisArray[i] + iS + ")\n"

			-- creates the ui (spinner and color tag)...			
			caUi += \
				"imgTag trs_img_" + tProp + axisArray[i] + iS + " bitmap:(bitmap 2 16 "+\
				"color:" + colorArray[i] + ") align:#left across:6\n"+\
				"spinner trs_spn_" + tProp + axisArray[i] + iS + " \"\" range:" + range + " "+\
				"width:40 align:#center scale:0.01 offset:[-12,0]\n"
		
			-- checks for the last loop iteration and the "scale" property...
			if i == 3 and tProp == "scale" do (
				
				-- creates the uniform scale checkbox...
				scaleCkGrp = \
					"label trs_lab_uniformScale" + iS + " \"use uniform scale\" align:#left across:2\n"+\
					"checkBox trs_ckb_uniformScale" + iS + " \"\" align:#right across:1 checked:false offset:[0,2]\n"
				
				-- sets the uniform scale event...
				scaleEventGrp = \
					"on trs_ckb_uniformScale" + iS + " changed state do (\n"+\
					"if trs_ckb_uniformScale" + iS + ".checked == true then (\n"+\
					"trs_spn_ScaleY" + iS + ".enabled = false; trs_spn_ScaleZ" + iS + ".enabled = false	\n"+\
					"trs_spn_ScaleY" + iS + ".value = trs_spn_ScaleX" + iS + ".value\n"+\
					"trs_spn_ScaleZ" + iS + ".value = trs_spn_ScaleX" + iS + ".value\n)\n"+\
					------------------------------------------------------------------------------------------------
					"else (trs_spn_ScaleY" + iS + ".enabled = true; trs_spn_ScaleZ" + iS + ".enabled = true)\n)\n"+\
					------------------------------------------------------------------------------------------------
					"on trs_spn_ScaleX" + iS + " changed val do (\n"+\
					"if trs_ckb_uniformScale" + iS + ".checked == true do (\n"+\
					"trs_spn_ScaleY" + iS + ".value = trs_spn_ScaleX" + iS + ".value\n"+\
					"trs_spn_ScaleZ" + iS + ".value = trs_spn_ScaleX" + iS + ".value\n)\n)\n"

				-- merges the "scale" to the custom attribute ui...
				caUi = scaleCkGrp + caUi + scaleEventGrp
				)
			)

		caUi += ")\n"

		return #(caParam,caUi)
		)
	)

caTransformSpinners_source = caTransformSpinners_source()