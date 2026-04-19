from core.services import process_user_input

test_cases = [
    "I need to send 15000 to my mother in Kisumu urgently",
    "I need an airport transfer from JKIA to Westlands tonight",
    "Please verify my land title in Nairobi",
    "Can someone clean my apartment in Westlands on Friday?",
    "Track my request status",
    "random nonsense input"
]

for msg in test_cases:
    print("\nINPUT:", msg)
    result = process_user_input(msg)
    print("OUTPUT:", result)
