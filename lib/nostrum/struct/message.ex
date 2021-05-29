defmodule Nostrum.Struct.Message do
  @moduledoc """
  Struct representing a Discord message.
  """

  alias Nostrum.Struct.{Channel, Embed, Guild, User}
  alias Nostrum.Struct.Guild.{Member, Role}
  alias Nostrum.Struct.Message.{Activity, Application, Attachment, Reaction, Reference}
  alias Nostrum.{Snowflake, Util}

  defstruct [
    :activity,
    :application,
    :attachments,
    :author,
    :channel_id,
    :content,
    :edited_timestamp,
    :embeds,
    :id,
    :guild_id,
    :member,
    :mention_everyone,
    :mention_roles,
    :mentions,
    :message_reference,
    :nonce,
    :pinned,
    :reactions,
    :referenced_message,
    :timestamp,
    :tts,
    :type,
    :webhook_id
  ]

  @typedoc "The id of the message"
  @type id :: Snowflake.t()

  @typedoc "The id of the guild"
  @type guild_id :: Guild.id() | nil

  @typedoc "The id of the channel"
  @type channel_id :: Channel.id()

  @typedoc "The user struct of the author"
  @type author :: User.t()

  @typedoc "The content of the message"
  @type content :: String.t()

  @typedoc "When the message was sent"
  @type timestamp :: String.t()

  @typedoc "When the message was edited"
  @type edited_timestamp :: String.t() | nil

  @typedoc "Whether this was a TTS message"
  @type tts :: boolean

  @typedoc "Whether this messsage mentions everyone"
  @type mention_everyone :: boolean

  @typedoc "List of users mentioned in the message"
  @type mentions :: [User.t()]

  @typedoc "List of roles ids mentioned in the message"
  @type mention_roles :: [Role.id()]

  @typedoc "List of attached files in the message"
  @type attachments :: [Attachment.t()]

  @typedoc "List of embedded content in the message"
  @type embeds :: [Embed.t()]

  @typedoc """
  Reactions to the message.
  """
  @type reactions :: [Reaction.t()] | nil

  @typedoc "Validates if a message was sent"
  @type nonce :: String.t() | nil

  @typedoc "Whether this message is pinned"
  @type pinned :: boolean

  @typedoc """
  If the message is generated by a webhook, this is the webhook's id.
  """
  @type webhook_id :: Snowflake.t() | nil

  @typedoc """
  [Type of message](https://discord.com/developers/docs/resources/channel#message-object-message-types).
  """
  @type type :: integer

  @typedoc """
  The activity of the message. Sent with Rich Presence-related chat embeds.
  """
  @type activity :: Activity.t() | nil

  @typedoc """
  The application of the message. Sent with Rich Presence-related chat embeds.
  """
  @type application :: Application.t() | nil

  @typedoc """
  Partial Guild Member object received with the Message Create event if message came from a guild channel.
  """
  @type member :: Member.t() | nil

  @typedoc """
  Reference data sent with crossposted messages and replies
  """
  @type message_reference :: Reference.t() | nil

  @typedoc """
  The message associated with the message_reference

  This field is only returned for messages with a type of 19 (REPLY). If the message is a reply but the
  referenced_message field is not present, the backend did not attempt to fetch the message that was being replied to,
  so its state is unknown. If the field exists but is null, the referenced message was deleted.
  """
  @type referenced_message :: t() | nil

  @type t :: %__MODULE__{
          activity: activity,
          application: application,
          attachments: attachments,
          author: author,
          channel_id: channel_id,
          content: content,
          edited_timestamp: edited_timestamp,
          embeds: embeds,
          id: id,
          guild_id: guild_id,
          member: member,
          mention_everyone: mention_everyone,
          mention_roles: mention_roles,
          mentions: mentions,
          message_reference: message_reference,
          nonce: nonce,
          pinned: pinned,
          reactions: reactions,
          referenced_message: referenced_message,
          timestamp: timestamp,
          tts: tts,
          type: type,
          webhook_id: webhook_id
        }

  @doc false
  def p_encode do
    %__MODULE__{
      author: User.p_encode(),
      mentions: [User.p_encode()],
      embeds: [Embed.p_encode()]
    }
  end

  @doc false
  def to_struct(map) do
    new =
      map
      |> Map.new(fn {k, v} -> {Util.maybe_to_atom(k), v} end)
      |> Map.update(:id, nil, &Util.cast(&1, Snowflake))
      |> Map.update(:guild_id, nil, &Util.cast(&1, Snowflake))
      |> Map.update(:channel_id, nil, &Util.cast(&1, Snowflake))
      |> Map.update(:author, nil, &Util.cast(&1, {:struct, User}))
      |> Map.update(:mentions, nil, &Util.cast(&1, {:list, {:struct, User}}))
      |> Map.update(:mention_roles, nil, &Util.cast(&1, {:list, Snowflake}))
      |> Map.update(:attachments, nil, &Util.cast(&1, {:list, {:struct, Attachment}}))
      |> Map.update(:embeds, nil, &Util.cast(&1, {:list, {:struct, Embed}}))
      |> Map.update(:reactions, nil, &Util.cast(&1, {:list, {:struct, Reaction}}))
      |> Map.update(:nonce, nil, &Util.cast(&1, Snowflake))
      |> Map.update(:webhook_id, nil, &Util.cast(&1, Snowflake))
      |> Map.update(:activity, nil, &Util.cast(&1, {:struct, Activity}))
      |> Map.update(:application, nil, &Util.cast(&1, {:struct, Application}))
      |> Map.update(:member, nil, &Util.cast(&1, {:struct, Member}))
      |> Map.update(:message_reference, nil, &Util.cast(&1, {:struct, Reference}))
      |> Map.update(:referenced_message, nil, &Util.cast(&1, {:struct, __MODULE__}))

    struct(__MODULE__, new)
  end

  @doc """
  Takes the message and produces a URL that, when clicked from the user client, will 
  jump them to that message, assuming they have access to the message and the message 
  is valid.
  """
  def to_url(%__MODULE__{} = msg) do
    "https://discord.com/channels/" <>
      (msg.guild_id || "@me") <> "/" <> msg.channel_id <> "/" <> msg.id
  end
end
