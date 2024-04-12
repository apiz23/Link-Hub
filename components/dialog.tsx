import { Pressable } from "react-native";
import { Button, Dialog, ToggleGroup } from "tamagui";
import { Link } from "expo-router";
import {
	AlignCenter,
	AlignLeft,
	AlignRight,
	Delete,
	Edit3,
	ExternalLink,
	Folder,
	X,
} from "@tamagui/lucide-icons";
import { Text, View } from "@/components/Themed";
import { Link as LinkType } from "@/types";
import { deleteLink } from "@/api/link";

interface DialogComponentProps {
	link: LinkType;
	templateId?: number;
}

export default function DialogComponent({
	link,
	templateId = 1,
}: DialogComponentProps) {
	const handleDelete = async (id: any) => {
		try {
			await deleteLink(id);
		} catch (error) {
			console.error(`Unexpected error while deleting link with ID ${id}:`, error);
		}
	};

	const renderDialogContent = () => {
		switch (templateId) {
			case 1:
				return (
					<>
						<Dialog.Title>{link.name}</Dialog.Title>
						<Dialog.Description>{link.url}</Dialog.Description>
						<ToggleGroup
							orientation="horizontal"
							type="single"
							size="$5"
							disableDeactivation
						>
							<ToggleGroup.Item value="left" aria-label="Left aligned">
								<Edit3 />
							</ToggleGroup.Item>
							<ToggleGroup.Item value="right" aria-label="Right aligned">
								<Delete
									onPress={() => {
										handleDelete(link.id);
									}}
								/>
							</ToggleGroup.Item>
						</ToggleGroup>
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
					</>
				);

			default:
				return (
					<>
						<Dialog.Title>{link.name}</Dialog.Title>
						<Dialog.Description>{link.url}</Dialog.Description>
						<Link href={link.url} asChild>
							<Button style={styles.buttonDialog} icon={<ExternalLink size={20} />} />
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
					</>
				);
		}
	};

	return (
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
						{renderDialogContent()}
					</Dialog.Content>
				</Dialog.Portal>
			</Dialog>
		</Pressable>
	);
}

const styles = {
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
	buttonDialog: {
		marginTop: 25,
		alignSelf: "flex-end",
	},
};
