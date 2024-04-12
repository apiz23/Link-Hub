import { StyleSheet, Pressable } from "react-native";
import { View } from "@/components/Themed";
import { useState, useEffect } from "react";
import { Button, H1, ScrollView } from "tamagui";
import { RefreshCw } from "@tamagui/lucide-icons";
import { fetchLinks } from "@/api/link";
import { Link as LinkType } from "@/types";
import DialogComponent from "@/components/dialog";

export default function Home() {
	const [links, setLinks] = useState<LinkType[]>([]);

	useEffect(() => {
		fetchLinks()
			.then((fetchedLinks) => {
				if (fetchedLinks) {
					setLinks(fetchedLinks);
				}
			})
			.catch((error) => {
				console.error("Error fetching links:", error);
			});
	}, []);

	return (
		<View style={styles.container}>
			<H1 style={styles.title}>Links</H1>
			<Button icon={RefreshCw} onPress={fetchLinks}>
				Refresh
			</Button>
			<ScrollView
				width="100%"
				padding="$1"
				borderRadius="$4"
				style={styles.scrollView}
			>
				<View style={styles.table}>
					{links.map((link) => (
						<Pressable key={link.id}>
							<DialogComponent key={link.id} link={link} templateId={0} />
						</Pressable>
					))}
				</View>
			</ScrollView>
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
	table: {
		padding: 10,
		backgroundColor: "transparent",
		margin: 10,
	},
	title: {
		fontSize: 50,
		fontWeight: "bold",
		marginBottom: 35,
		paddingTop: 80,
	},
	item: {
		padding: 20,
		borderBottomWidth: 1,
		borderBottomColor: "#ccc",
		width: "100%",
	},
	scrollView: {
		width: "100%",
		marginBottom: 100,
	},
	dialogTriggerText: {
		width: "100%",
	},
});
