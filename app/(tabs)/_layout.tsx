import React from "react";
import { Tabs } from "expo-router";
import { AntDesign } from "@expo/vector-icons";

import Colors from "@/constants/Colors";
import { useColorScheme } from "@/components/useColorScheme";

export default function TabLayout() {
	const colorScheme = useColorScheme();
	const iconColor = colorScheme === "dark" ? "white" : "black";

	return (
		<Tabs
			screenOptions={{
				tabBarActiveTintColor: Colors[colorScheme ?? "light"].tint,
				headerShown: false,
			}}
		>
			<Tabs.Screen
				name="index"
				options={{
					title: "Home",
					tabBarIcon: () => <AntDesign name="home" size={24} color={iconColor} />,
				}}
			/>
			<Tabs.Screen
				name="crud"
				options={{
					title: "Crud",
					tabBarIcon: () => (
						<AntDesign name="codesquareo" size={24} color={iconColor} />
					),
				}}
			/>
			<Tabs.Screen
				name="setting"
				options={{
					title: "Settings",
					tabBarIcon: () => <AntDesign name="setting" size={24} color={iconColor} />,
				}}
			/>
		</Tabs>
	);
}
