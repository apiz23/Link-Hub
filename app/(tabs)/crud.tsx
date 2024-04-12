import { Pressable, StyleSheet } from "react-native";
import { Text, View } from "@/components/Themed";
import {
	Button,
	Form,
	H1,
	Input,
	Label,
	ScrollView,
	Sheet,
	Spinner,
	ToggleGroup,
} from "tamagui";
import { useEffect, useState } from "react";
import { AntDesign } from "@expo/vector-icons";
import { ChevronDown, Folder, RefreshCw } from "@tamagui/lucide-icons";
import { useColorScheme } from "@/components/useColorScheme";
import { supabase } from "@/lib/supabase";
import { Link, fetchLinks } from "@/api/link";
import DialogComponent from "@/components/dialog";

export default function Crud() {
	const colorScheme = useColorScheme();

	const [links, setLinks] = useState<Link[]>([]);
	const iconColor = colorScheme === "dark" ? "white" : "black";
	const [open, setOpen] = useState(false);
	const [modal, setModal] = useState(true);
	const [status, setStatus] = useState<"off" | "submitting" | "submitted">(
		"off"
	);

	const [name, setName] = useState("");
	const [url, setUrl] = useState("");

	useEffect(() => {
		if (status === "submitting") {
			const timer = setTimeout(() => setStatus("off"), 2000);
			return () => {
				clearTimeout(timer);
			};
		}
		fetchLinks()
			.then((fetchedLinks) => {
				if (fetchedLinks) {
					setLinks(fetchedLinks);
				}
			})
			.catch((error) => {
				console.error("Error fetching links:", error);
			});
	}, [status]);

	const handleAdd = async () => {
		setStatus("submitting");

		const { data, error } = await supabase
			.from("link_hub")
			.insert([{ name, url }])
			.select();

		if (error) {
			console.error("Error inserting data:", error);
			setStatus("off");
			return;
		}

		console.log("Data inserted successfully:", data);
		setStatus("submitted");
		setName("");
		setUrl("");
		setOpen(false);
	};

	return (
		<View style={styles.container}>
			<H1>CRUD</H1>
			<ToggleGroup
				orientation="horizontal"
				type="single"
				size="$6"
				disableDeactivation
				justifyContent="flex-end"
			>
				<ToggleGroup.Item value="addFile" onPress={() => setOpen(true)}>
					<AntDesign name="addfile" size={24} color={iconColor} />
				</ToggleGroup.Item>
				<ToggleGroup.Item value="reload" onPress={fetchLinks}>
					<AntDesign name="reload1" size={24} color={iconColor} />
				</ToggleGroup.Item>
			</ToggleGroup>

			<ScrollView
				width="100%"
				padding="$5"
				borderRadius="$4"
				style={styles.scrollView}
			>
				{links.map((link) => (
					<>
						<Pressable key={link.id}>
							<DialogComponent key={link.id} link={link} templateId={1} />
						</Pressable>
					</>
				))}
			</ScrollView>
			<Sheet
				modal={modal}
				open={open}
				onOpenChange={setOpen}
				snapPoints={undefined}
				dismissOnSnapToBottom
				animation="medium"
			>
				<Sheet.Overlay />
				<Sheet.Handle />
				<Sheet.Frame
					padding="$4"
					justifyContent="center"
					alignItems="center"
					backgroundColor="#fff"
				>
					<Button
						circular
						icon={ChevronDown}
						onPress={() => setOpen(false)}
						marginVertical="$4"
					/>
					<View
						style={{
							height: "90%",
							width: "100%",
							backgroundColor: "transparent",
							padding: 20,
						}}
					>
						<H1>Add Data</H1>
						<Form onSubmit={handleAdd} backgroundColor="$colorTransparent">
							<Label width={90} htmlFor="name" color="black">
								Name
							</Label>
							<Input
								id="name"
								value={name}
								placeholder="Name of the link"
								onChangeText={(text) => {
									setName(text);
								}}
							/>
							<Label width={90} htmlFor="url" color="black">
								Url
							</Label>
							<Input
								id="url"
								value={url}
								placeholder="https://google.com.my"
								onChangeText={(text) => {
									setUrl(text);
								}}
							/>
							<Form.Trigger asChild disabled={status !== "off"}>
								<Button
									themeInverse
									icon={status === "submitting" ? () => <Spinner /> : undefined}
									style={styles.btnSubmit}
								>
									Submit
								</Button>
							</Form.Trigger>
						</Form>
					</View>
				</Sheet.Frame>
			</Sheet>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		paddingTop: 100,
		flex: 1,
		width: "100%",
	},
	triggerContent: {
		flexDirection: "row",
		justifyContent: "space-between",
		alignItems: "center",
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
	btnSubmit: {
		marginTop: 20,
	},
	scrollView: {
		width: "100%",
		marginBottom: 100,
	},
});
