struct caTransformSpinners_source (

	-- contains the item label for the main ui...
	attributeLabel = "transform spinners xyz",

	-- contains the strings to setup the custom attributes...
	fn setUpUiPrp iS = (

		range1 = "[-99999999999,99999999999,-9999]"
		range2 = "[-99999999999,99999999999,9999]"
		setPropGrp = \
			"group \" transform spinners xyz: \" (\n"+\
			"radiobuttons rdo_trm" + iS + " \"\" labels:#(\"pos\",\"rot\",\"scale\") align:#left columns:1 offset:[0,2]\n" +\
			"imgTag img_" + iS + "X bitmap:(bitmap 2 12 color:red) align:#center offset:[-34,-52]\n"+\
			"spinner ui_spnX_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnX_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			"imgTag img_" + iS + "Y bitmap:(bitmap 2 12 color:green) align:#center offset:[-34,0]\n"+\
			"spinner ui_spnY_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnY_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			"imgTag img_" + iS + "Z bitmap:(bitmap 2 12 color:blue) align:#center offset:[-34,0]\n"+\
			"spinner ui_spnZ_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnZ_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n)\n"

		return setPropGrp
		),

	-- contains the strings for the custom attributes rollout...
	fn caParamUi uiIndex rollName minArray maxArray propIndex = (

		iS = uiIndex as string
		trm = #("position","rotation","scale"); tProp = trm[propIndex]
		colorArray = #("red","green","blue"); axisArray = #("X","Y","Z")

		caParam = ""
		caUi = "group \" " + tProp + ": \" (\n"

		for i in 1 to 3 do (
			defValueS = ((minArray[i] + maxArray[i]) / 2) as string
			range = "[" + minArray[i] as string + "," + maxArray[i] as string + "," + defValueS + "]"
			
			-- sets the parameter block...
			caParam +=
				"'" + iS + "_" + tProp + axisArray[i] + "' type:#float "+\
				"default:" + defValueS + " ui:(spn_" + tProp + axisArray[i] + iS + ")\n"

			-- creates the ui (spinner and color tag)...
			caUi += \
				"imgTag img_" + tProp + axisArray[i] + iS + " bitmap:(bitmap 2 16 "+\
				"color:" + colorArray[i] + ") align:#left offset:[0,0]\n"+\
				"spinner spn_" + tProp + axisArray[i] + iS + " \"\" range:" + range + " "+\
				"width:136 align:#center scale:0.01 offset:[2,-20]\n"
		
			-- checks for the last loop iteration and the "scale" property...
			if i == 3 and tProp == "scale" do (
				
				-- creates the uniform scale checkbox...
				scaleCkGrp = \
					"label lab_uniformScale" + iS + " \"uniform scale\" align:#left across:2\n"+\
					"checkBox ckb_uniformScale" + iS + " \"\" align:#right across:1 checked:false offset:[10,0]\n"
				
				-- sets the uniform scale event...
				scaleEventGrp = \
					"on ckb_uniformScale" + iS + " changed state do (\n"+\
					"if ckb_uniformScale" + iS + ".checked == true then (\n"+\
					"spn_ScaleY" + iS + ".enabled = false; spn_ScaleZ" + iS + ".enabled = false	\n"+\
					"spn_ScaleY" + iS + ".value = spn_ScaleX" + iS + ".value\n"+\
					"spn_ScaleZ" + iS + ".value = spn_ScaleX" + iS + ".value\n)\n"+\
					"else (spn_ScaleY" + iS + ".enabled = true; spn_ScaleZ" + iS + ".enabled = true)\n)\n"+\
					"on spn_ScaleX" + iS + " changed val do (\n"+\
					"if ckb_uniformScale" + iS + ".checked == true do (\n"+\
					"spn_ScaleY" + iS + ".value = spn_ScaleX" + iS + ".value\n"+\
					"spn_ScaleZ" + iS + ".value = spn_ScaleX" + iS + ".value\n)\n)\n"

				-- merges the "scale" to the custom attribute ui...
				caUi = scaleCkGrp + caUi + scaleEventGrp
				)
			)
		caUi += ")\n"

		return #(caParam,caUi)
		)
	)

caTransformSpinners_source = caTransformSpinners_source()