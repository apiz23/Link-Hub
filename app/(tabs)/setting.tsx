import { StyleSheet } from "react-native";
import { Text, View } from "@/components/Themed";
import { H1 } from "tamagui";

export default function Settings() {
	return (
		<View style={styles.container}>
			<H1 style={styles.title}>Settings</H1>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: "center",
		paddingTop: 50,
		paddingHorizontal: 20,
	},
	title: {
		fontSize: 50,
		fontWeight: "bold",
		marginBottom: 35,
		paddingTop: 80,
	},
	separator: {
		marginVertical: 30,
		height: 1,
		width: "100%",
	},
});
