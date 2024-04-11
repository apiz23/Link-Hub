import { StyleSheet, Pressable } from "react-native";
import { Text, View } from "@/components/Themed";
import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import { Button, H1, Dialog, ScrollView } from "tamagui";
import { Link } from "expo-router";
import { ExternalLink, Folder, RefreshCw, X } from "@tamagui/lucide-icons";

interface Link {
	id: string;
	name: string;
	url: string;
	created_at: string;
}

export default function Home() {
	const [links, setLinks] = useState<Link[]>([]);

	const fetchLinks = async () => {
		try {
			const { data: linkHub, error } = await supabase.from("link_hub").select("*");

			if (error) {
				console.error("Error fetching links:", error.message);
				return;
			}

			if (linkHub && linkHub.length > 0) {
				setLinks(linkHub);
			}
		} catch (error: any) {
			console.error("Error fetching links:", error.message);
		}
	};

	useEffect(() => {
		fetchLinks();
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
							<Dialog>
								<Dialog.Trigger style={styles.dialogTrigger}>
									<View style={styles.triggerContent}>
										<Text>{link.name}</Text>
										<Folder />
									</View>
								</Dialog.Trigger>

								<Dialog.Portal>
									<Dialog.Overlay />
									<Dialog.Content
										bordered
										elevate
										key="content"
										animateOnly={["transform", "opacity"]}
										animation={[
											"quicker",
											{
												opacity: {
													overshootClamping: true,
												},
											},
										]}
										enterStyle={{ x: 0, y: -20, opacity: 0, scale: 0.9 }}
										exitStyle={{ x: 0, y: 10, opacity: 0, scale: 0.95 }}
										gap={4}
										style={{ width: "90%" }}
									>
										<Dialog.Title>{link.name}</Dialog.Title>
										<Dialog.Description>{link.url}</Dialog.Description>
										<Link href={link.url} asChild>
											<Button
												style={styles.buttonDialog}
												icon={<ExternalLink size={20} />}
											/>
										</Link>
										<Dialog.Close asChild>
											<Button
												position="absolute"
												top={3}
												right={3}
												size={30}
												circular
												icon={X}
												margin={5}
											/>
										</Dialog.Close>
									</Dialog.Content>
								</Dialog.Portal>
							</Dialog>
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
	buttonDialog: {
		marginTop: 25,
		alignSelf: "flex-end",
	},
	dialogTrigger: {
		width: "100%",
		borderBottomWidth: 1,
		borderBottomColor: "#ccc",
		padding: 10,
	},
	triggerContent: {
		flexDirection: "row",
		justifyContent: "space-between",
		alignItems: "center",
	},
	dialogTriggerText: {
		width: "100%",
	},
});
