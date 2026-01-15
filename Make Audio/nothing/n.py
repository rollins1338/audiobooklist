import json
import os

FILE_NAME = "contacts.json"

def load_contacts():
    if os.path.exists(FILE_NAME):
        with open(FILE_NAME, "r") as f:
            return json.load(f)
    return {}

def save_contacts(contacts):
    with open(FILE_NAME, "w") as f:
        json.dump(contacts, f, indent=4)

def add_contact(contacts):
    name = input("Enter Name: ").strip()
    number = input("Enter Number: ").strip()
    contacts[name] = number
    print(f"✅ Saved {name}!")

def view_contacts(contacts):
    print("\n--- 📒 Your Contacts ---")
    if not contacts: print("No contacts found.")
    for name, num in contacts.items():
        print(f"{name}: {num}")
    print("------------------------\n")

def delete_contact(contacts):
    name = input("Name to delete: ").strip()
    if contacts.pop(name, None):
        print(f"🗑️ Deleted {name}.")
    else:
        print("❌ Contact not found.")

def main():
    contacts = load_contacts()
    while True:
        choice = input("1.Add  2.View  3.Delete  4.Exit\nChoose: ")
        
        if choice == '1':
            add_contact(contacts)
        elif choice == '2':
            view_contacts(contacts)
        elif choice == '3':
            delete_contact(contacts)
        elif choice == '4':
            save_contacts(contacts)
            print("💾 Saved & Goodbye!")
            break
        else:
            print("Invalid choice, try again.")

if __name__ == "__main__":
    main()
