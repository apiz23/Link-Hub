import { StyleSheet } from "react-native";
import { Text, View } from "@/components/Themed";

export default function Settings() {
	return (
		<View style={styles.container}>
			<Text>Setting</Text>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		paddingTop: 50,
		flex: 1,
		width: "100%",
	},
	title: {
		paddingTop: 40,
		fontSize: 20,
		fontWeight: "bold",
	},
	separator: {
		marginVertical: 30,
		height: 1,
		width: "100%",
	},
});
